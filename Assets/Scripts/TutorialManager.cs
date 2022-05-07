using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;

public class TutorialManager : MonoBehaviour
{
    public static TutorialManager instance;
    public GameObject[] Panels;
    public int state = 0;
    private void Awake()
    {
        instance = this;

        SetPanelState();
    }
    public void SetPanelState()
    {
        foreach (GameObject g in Panels)
            g.SetActive(false);

        if(state<Panels.Length)
        Panels[state].SetActive(true);
    }
    public void SetNextTutorial()
    {
        SetTutorialStatus(state+1);
    }
    public void SetTutorialStatus(int status)
    {
        if (status <= state) return;
        state= status;
        SetPanelState();
    }
    
}
