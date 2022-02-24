using Planner;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveAction : Action
{
    public string move { get; set; }
    public bool emergency { get; set; }
    public int xNext { get; set; }

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
        Player myPlayer = FindObjectOfType<Player>();
        if (myPlayer == null)
            return State.ABORT;

        if (emergency && GameObject.Find("Missile(Clone)") == null)
            return State.ABORT;

        if (!emergency && System.Math.Abs(xNext-myPlayer.GetComponent<IntPair>().x) > 100)
            return State.SKIP;

        return State.READY;
    }
}
