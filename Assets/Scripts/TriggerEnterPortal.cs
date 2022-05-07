using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerEnterPortal : MonoBehaviour
{
    public bool isInternal;
    //if player enter the portal switch between ingression
    private void OnTriggerEnter(Collider other)
    {
        ManagerSwitchIngressionPortal.instance.SwitchBetweenEnter(isInternal);
        Debug.Log(other.name);
    }
 
}
