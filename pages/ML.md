# ML

## Search

- Go from Node A to Node B in a graph
   ![node a data structure that keeps track of - a state - a parent (node that generated this node) - an action (action applied to parent to get node) - a path cost (from initial state to node) ](../assets/Exported_image_20241121214047-0.png)
- Action(node) -> new node
- Algorithm:
   ![Revised Approach • Start with a frontier that contains the initial state. • Start with an empty explored set. • Repeat: he frontier is empty, then no solution. Ret-nove a node from the frontier. • If node contains goal state. return the solution. • Add the node to the explored set. • Expand node. add resulting nodes to the frontier if they aren't already in the frontier Or the explored set. ](../assets/Exported_image_20241121214052-1.png)

  1. Start with the Frontier containing initial Node - type of Frontier determines search algorithm
  2. Select 1 from the Frontier (Queue or Stack frontier will behave differently)
  3. If selected Node == goal -> END
  4. Else Explore (apply Action to Node) selected node and
	- 1. Add new Nodes to frontier
	- 2. Add node to Explored set
- 5. Repeat 2

- Search Algorithms:
  - Breadth first search (explore siblings before traversing a branch,
    implemented using a QueueFrontier)
  - Depth first search (explore depth before traversing siblings, implemented
    using a StackFrontier)
  - Greedy best first use a heuristic function to evict a node from frontier)
    ![Greedy Best-First Search 11 13 14 16 10 11 13 15 12 14 ](../assets/Exported_image_20241121214054-2.png)  
    ![A* search search algorithm that expands node with lowest value of g(n) + h(n) g(n) = cost to reach node h(n) = estimated cost to goal ](../assets/Exported_image_20241121214058-3.png)  
    ![actions choices that can be made in a state ](../assets/Exported_image_20241121214103-4.png)  
    ![actions ACTIONS(s) returns the set of actions that can be executed in state s ](../assets/Exported_image_20241121214107-5.png)  
    ![transition model a description of what state results from performing any applicable action in any state ](../assets/Exported_image_20241121214111-6.png)  
    ![transition model RESULT(s, a) returns the state resulting from performing action a in state s ](../assets/Exported_image_20241121214113-7.png)  
    ![RESULT( 4 9 8 RESULT( 4 9 6 13 3 6 13 10 15 1 10 111 1 11 12 8 4 9 2 8 3 6 13 4 3 1 5 1 11 12 15 11 ](../assets/Exported_image_20241121214118-8.png)
    ![8 RESULT( 14 4 3 6 1 10 11 12 ](../assets/Exported_image_20241121214120-9.png)  
    ![Exported image](../assets/Exported_image_20241121214122-10.png)
- Path cost
  ![Search Problems • initial state • actions • transition model • goal test • path cost function ](../assets/Exported_image_20241121214124-11.png)
- **Concepts**
  - **Search Algorithm**

    ![Minimax • MAX (X) aims to maximize score. • MIN (O) aims to minimize score. ](../assets/Exported_image_20241121214125-12.png)  
    ![Game •So : initial state • PLAYER(s) : returns which player to move in state s • ACTIONS(s) : returns legal moves in state s • RESULT(s, a) : returns state after action a taken in state s • TERMINAL(s) : checks if state s is a terminal state • UTILIN(s) : final numerical value for terminal state s ](../assets/Exported_image_20241121214128-13.png)  
    ![that a teminal state. And then finally We'll need a utility function. a function that take Md gives us a numerical Value for that terminal State, some Wa f X wins the game, that has a value of 1. f O has won the game. that has the value Of negative ](../assets/Exported_image_20241121214130-14.png)

    **Adverserial Search**

    ![PLAYER( )=о PLAYER( х ](../assets/Exported_image_20241121214135-15.png)
    ![ACTIONS 冖 s) × 0 × 0 ](../assets/Exported_image_20241121214137-16.png)
    ![RESULT(s, a) ](../assets/Exported_image_20241121214139-17.png)
    ![TERMINAL(s) о TERMINAL( О Х Х о о TERMINAL( О Х Х о х х false = tpue ](../assets/Exported_image_20241121214142-18.png)
    ![UTILITY(s) о UTILITY( О х о UTILITY( Х о х о х х -1 о ](../assets/Exported_image_20241121214145-19.png)
    ![MIN-VALUE: Х о О охо UEoxx Х о LUE: х О о о ох х Х MAX-VALUE: ”'ALUE: ох х Х х хо ох х х ](../assets/Exported_image_20241121214147-20.png)

    O minimize value  
    X maximize value√

    ![PLAYER(s) = Х MAX-VALUE: х хо Х О х хо х хо х 00 о ](../assets/Exported_image_20241121214149-21.png)
- ## Knowledge
  ![sentence an assertion about the world in a knowledge representation language ](../assets/Exported_image_20241121214155-0.png)

![Logical Connectives not implication and or biconditional ](../assets/Exported_image_20241121214157-1.png)

![Implication ( ) false a15 t rue true P false false true true Q P*Q false true true true ](../assets/Exported_image_20241121214159-2.png)  
![Biconditional (e) false false true true false true false true true false false true ](../assets/Exported_image_20241121214201-3.png)

![model assignment of a truth value to every propositional symbol (a "possible world") ](../assets/Exported_image_20241121214203-4.png)

![model P: It is raining. Q: It is a Tuesday. {P = true, Q = false} ](../assets/Exported_image_20241121214204-5.png)  
![Entailment In every model in which sentence is true, sentence is also true. ](../assets/Exported_image_20241121214206-6.png)

![inference the process of deriving new sentences from old ones ](../assets/Exported_image_20241121214211-7.png)
![P: It is a Tuesday. Q: It is raining. R: Harry will go for a run. Inference: R ](../assets/Exported_image_20241121214212-8.png)
