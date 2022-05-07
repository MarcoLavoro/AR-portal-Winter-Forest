using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ManagerSwitchIngressionPortal : MonoBehaviour
{
    public enum statePlayer
    {
        External,
        Internal,
    }

    public statePlayer actualState = statePlayer.External;
    public static ManagerSwitchIngressionPortal instance;
    public GameObject ExtenalSide;
    public GameObject PortaExternalOcclusion;
    public GameObject PortalInternalOcclusion;

    private void Awake()
    {
        instance = this;
        SwitchBetweenEnter(false);
    }
    public void SwitchBetweenEnter(bool enteredOtherWord)
    {

        if (enteredOtherWord)
        {
            ExtenalSide.SetActive(true);
            PortaExternalOcclusion.SetActive(false);
            PortalInternalOcclusion.SetActive(true);
        }
        else
        {
            ExtenalSide.SetActive(false);
            PortaExternalOcclusion.SetActive(true);
            PortalInternalOcclusion.SetActive(false);
        }
    }
}
