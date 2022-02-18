using Planner;
using System.Collections;
using System.Collections.Generic;
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
        //State must be returned using State.WAIT|State.ABORT|State.READY
        if (FindObjectOfType<Player>() == null)
            return State.ABORT;

        if (!belongingTO.IsExecuting && GameObject.Find("Planner").GetComponent<PlannerBrainsCoordinator>().priorityExecuting == belongingTO.priority)
            return State.WAIT;

        return State.READY;
    }
}