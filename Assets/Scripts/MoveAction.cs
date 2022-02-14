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
        FindObjectOfType<Player>().Move(move);

        throw new System.NotImplementedException();
    }

    public override bool Done()
    {
        return true;
    }

    public override State Prerequisite()
    {
        // qui va controllato il fatto di non uscire dalle pareti? credo sia inutile
        throw new System.NotImplementedException();
    }
}
