using Planner;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveAction : Action
{
    string move { get; set; }
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
        //State must be returned using State.WAIT|State.ABORT|State.READY
        if (FindObjectOfType<Player>() == null)
        {
//            Debug.Log("MOVE - ABORT");
            return State.ABORT;
        }
        /*
        if (!belongingTO.IsExecuting && GameObject.Find("Planner").GetComponent<PlannerBrainsCoordinator>().priorityExecuting == belongingTO.priority)
        {
            Debug.Log("MOVE - WAIT");
            return State.WAIT;
        }
        */
//        Debug.Log("MOVE - READY");
        return State.READY;
    }
}
