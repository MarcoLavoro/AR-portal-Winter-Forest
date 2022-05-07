using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;

[RequireComponent(typeof(ARPlane), typeof(ARPlaneMeshVisualizer))]
public class ARPlaneDetectDimension : MonoBehaviour
{
    ARPlane m_Plane;
    ARPlaneMeshVisualizer m_PlaneMeshVisualizer;

    // Start is called before the first frame update
    private void Awake()
    {
        m_Plane = GetComponent<ARPlane>();
        m_PlaneMeshVisualizer = GetComponent<ARPlaneMeshVisualizer>();
    }

    // Update is called once per frame
    void OnEnable()
    {
        m_Plane.boundaryChanged += ARPlane_boundaryUpdated;
    }

    void OnDisable()
    {
        m_Plane.boundaryChanged -= ARPlane_boundaryUpdated;
    }
    //note: a better approach would be use a UnityEvent.
    //If a plane is big enough go to the next step (or do an action)
    void ARPlane_boundaryUpdated(ARPlaneBoundaryChangedEventArgs eventArgs)
    {
            float area = CalculateSurfaceArea(m_PlaneMeshVisualizer.mesh);
        if (area > 0.2f)
            TutorialManager.instance.SetTutorialStatus(1);
    }

    float CalculateSurfaceArea(Mesh mesh)
    {
        var triangles = mesh.triangles;
        var vertices = mesh.vertices;

        double sum = 0.0;

        for (int i = 0; i < triangles.Length; i += 3)
        {
            Vector3 corner = vertices[triangles[i]];
            Vector3 a = vertices[triangles[i + 1]] - corner;
            Vector3 b = vertices[triangles[i + 2]] - corner;

            sum += Vector3.Cross(a, b).magnitude;
        }

        return (float)(sum / 2.0);
    }
}
