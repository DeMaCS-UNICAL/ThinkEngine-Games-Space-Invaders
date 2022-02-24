using System;
using UnityEngine;
using Planner;

// every method of this class without parameters and that returns a bool value can be used to trigger the reasoner.
public class Trigger:ScriptableObject
{
    bool RunReasoner()
    {
        if (!ChangePlan() && GameObject.Find("Planner").GetComponent<Scheduler>().ResidualActions < 3)
            return true;
        return false;
    }
    bool ChangePlan()
    {
        if (FindObjectOfType<Invaders>() != null && FindObjectOfType<Invaders>().AmountAlive <= FindObjectOfType<Invaders>().TotalAmount / 2)
            if (GameObject.Find("Planner").GetComponent<Scheduler>().ResidualActions < 3)
                return true;
        return false;
    }

    bool EmergencyPlan()
    {
        Player myPlayer = FindObjectOfType<Player>();
        GameObject missile = GameObject.Find("Missile(Clone)");
        if (missile != null && myPlayer != null && System.Math.Abs(missile.transform.position.x - myPlayer.transform.position.x) <
            myPlayer.GetComponent<BoxCollider2D>().size.x*2 && FindObjectOfType<PlannerBrainsCoordinator>().priorityExecuting!=1)
            return true;
        return false;
    }

}