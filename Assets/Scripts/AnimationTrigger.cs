using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class AnimationTrigger : MonoBehaviour
{
    //to have a more dynamic interaction i tried to create a list of possibile animation instead use animation triggers.

    //list of animation name, each state number is an animation, so you can perform different action in sequence
    public string[] AnimationName;
    public Animator animator;
    public int state = 0;
    private void Awake()
    {
        animator = GetComponentInChildren<Animator>();
        StartAnimation();
    }
    public void StartAnimation()
    {
        animator.Play(AnimationName[state]);
        state++;
        if (state >= AnimationName.Length)
            state = 0;
    }
}
