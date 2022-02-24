using Planner;
using UnityEngine;

public class FireAction : Action
{
    public override void Do()
    {
        FindObjectOfType<Player>().Shoot();
    }

    public override bool Done()
    {
        return true;
    }

    public override State Prerequisite()
    {
        // RECOMPUTE PLAN WHEN:
        // 1.ENEMIES DIRECTION CHANGES
        // 2.ENEMY KILLED
        Player myPlayer = FindObjectOfType<Player>();
        if (myPlayer == null) 
            return State.ABORT;

            return State.READY;
    }
}