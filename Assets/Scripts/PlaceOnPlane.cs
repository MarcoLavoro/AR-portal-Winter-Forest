using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;


    /// <summary>
    /// Listens for touch events and performs an AR raycast from the screen touch point.
    /// AR raycasts will only hit detected trackables like feature points and planes.
    ///
    /// If a raycast hits a trackable, the <see cref="placedPrefab"/> is instantiated
    /// and moved to the hit position.
    /// </summary>
[RequireComponent( typeof(ARPlaneManager), typeof(ARRaycastManager))]
public class PlaceOnPlane : MonoBehaviour
    {
        [SerializeField]
        [Tooltip("Action to do when the object is placed")]
        NormalEvent OnObjectPlaced;

        [SerializeField]
        [Tooltip("Instantiates this prefab on a plane at the touch location.")]
        GameObject m_PlacedPrefab;

        /// <summary>
        /// The prefab to instantiate on touch.
        /// </summary>
        public GameObject placedPrefab
        {
            get { return m_PlacedPrefab; }
            set { m_PlacedPrefab = value; }
        }

        /// <summary>
        /// The object instantiated as a result of a successful raycast intersection with a plane.
        /// </summary>
        public GameObject spawnedObject { get; private set; }

        static List<ARRaycastHit> s_Hits = new List<ARRaycastHit>();
        private ARRaycastManager m_RaycastManager;
        private ARPlaneManager planeManager;


    void Awake()
        {
            m_RaycastManager = GetComponent<ARRaycastManager>();
            planeManager = GetComponent<ARPlaneManager>();
        }

        bool TryGetTouchPosition(out Vector2 touchPosition)
        {
            if (Input.touchCount > 0)
            {
                touchPosition = Input.GetTouch(0).position;
                return true;
            }

            touchPosition = default;
            return false;
        }

        void Update()
        {

        foreach (ARPlane asd in planeManager.trackables)
        { 
        
        }
            if (!TryGetTouchPosition(out Vector2 touchPosition))
                return;

            if (m_RaycastManager.Raycast(touchPosition, s_Hits, TrackableType.PlaneWithinPolygon))
            {
                // Raycast hits are sorted by distance, so the first one
                // will be the closest hit.
                var hitPose = s_Hits[0].pose;


              if (spawnedObject == null)
              {
                  spawnedObject = Instantiate(m_PlacedPrefab, hitPose.position, hitPose.rotation);
                if (OnObjectPlaced != null)
                    OnObjectPlaced.Invoke();
              }
            //uncomment this code to let move move the portal
            //  else
            //  {
            //      spawnedObject.transform.position = hitPose.position;
            //  }
        }
    }


    public void StopTrackingPoints()
    {
        //whent the opbject is placed (or when I decidet to) remove the traking reference (plane, points and so on)
        planeManager.enabled = false;
        foreach (var plane in planeManager.trackables)
        {
            plane.gameObject.SetActive(false);
        }

        //In this case I not want to have the ability to relocate the portal
        this.enabled = false;
    }


}

[System.Serializable]
public class NormalEvent : UnityEvent
{ }

