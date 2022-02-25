using Planner;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireAction : Action
{
    int count = 20;
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
        if (count > 0)
        {
            count--;
            return State.WAIT;
        }
        //State must be returned using State.WAIT|State.ABORT|State.READY
        if (FindObjectOfType<Player>() == null)
        {
//            Debug.Log("FIRE - ABORT");
            return State.ABORT;
        }
        /*
        if (!belongingTO.IsExecuting && GameObject.Find("Planner").GetComponent<PlannerBrainsCoordinator>().priorityExecuting == belongingTO.priority)
        {
            Debug.Log("FIRE - WAIT");
            return State.WAIT;
        }
        */
//        Debug.Log("FIRE - READY");
        return State.READY;
    }
}