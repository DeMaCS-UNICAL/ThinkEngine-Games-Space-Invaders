using System;
using UnityEngine;
using Planner;

// every method of this class without parameters and that returns a bool value can be used to trigger the reasoner.
public class Trigger:ScriptableObject
{
    bool RunReasoner()
    {
        if (GameObject.Find("Planner").GetComponent<Scheduler>().ResidualActions < 3)
            return true;
        return false;
    }

}