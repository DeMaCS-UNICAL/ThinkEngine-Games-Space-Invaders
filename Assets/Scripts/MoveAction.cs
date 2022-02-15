using Planner;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveAction : Action
{
    string move { get; set; }
    public override void Do()
    {
        Debug.Log("MOVE ACTION - DO");
        // Player myPlayer = FindObjectOfType<Player>();
        FindObjectOfType<Player>().Move(move);
    }

    public override bool Done()
    {
        Debug.Log("MOVE ACTION - DONE");
        return true;
    }

    public override State Prerequisite()
    {
        Debug.Log("MOVE ACTION - PREREQUISITE");
        return State.READY;
    }
}
