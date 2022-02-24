using Planner;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveAction : Action
{
    string move { get; set; }
    public bool emergency { get; set; }

    public override void Do()
    {
        // Player myPlayer = FindObjectOfType<Player>();
        FindObjectOfType<Player>().previousDirection = move;
        FindObjectOfType<Player>().Move(move);
    }

    public override bool Done()
    {
        return true;
    }

    public override State Prerequisite()
    {
        if (emergency && GameObject.Find("Missile(Clone)") == null)
            return State.ABORT;

        Player myPlayer = FindObjectOfType<Player>();
        if (myPlayer == null)
            return State.ABORT;

        return State.READY;
    }
}
