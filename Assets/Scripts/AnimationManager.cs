using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class AnimationManager : MonoBehaviour
{
    public LayerMask mask;
    // Update is called once per frame
    void Update()
    {
        RaycastHit hitInfo;
        //If i press the a button (In this case the screen) I activate an animation if i hit an AnimationTrigger, i will use a raycast to obtain that
        //I use the mouse position only to speed up the development testing in the editor. (this is just a demo app)
        if (Input.GetMouseButtonDown(0))
            if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hitInfo, Mathf.Infinity, mask))
        {
           Transform target = hitInfo.collider.transform;
                if (target.GetComponentInChildren<AnimationTrigger>() != null)
                {
                    TutorialManager.instance.SetTutorialStatus(3);
                    target.GetComponentInChildren<AnimationTrigger>().StartAnimation();
                }
            }
    }



}
