using Planner;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireAction : Action
{
    public override void Do()
    {
        Debug.Log("FIRE ACTION - DO");
        FindObjectOfType<Player>().Shoot();
    }

    public override bool Done()
    {
        Debug.Log("FIRE ACTION - DONE");
        return true;
    }

    public override State Prerequisite()
    {
        Debug.Log("FIRE ACTION - PREREQUISITE");
        //State must be returned using State.WAIT|State.ABORT|State.READY
        return State.READY;
    }
}