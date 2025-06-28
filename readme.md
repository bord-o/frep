# FREP

F-Rep is a way of representing geometries and hypervolumes with a single function, which enables set theoretic operations and some interesting 
advantages over B-Rep, which is used in most CAD/CAM/FEA applications

## TODO:
[ x ] - Define primitives
[ x ] - Create tree structure (main model for constructive geometry)
[ x ] - Figure out what math/number library to use (Zarith?)
[ x ] - Implement point cloud library (this was simple)
[ x ] - Sample my function in bounding box to get vertices
[ ] - Decompose the synthesis problem

---

## The Problem

The synthesis tree is simple, with the main operations being:
	```ocaml
	
	type op =
	  | Neg of obj
	  | Metamorphosis of obj * obj * float
	  | Union of obj * obj
	  | Intersection of obj * obj
	  | Subtraction of obj * obj
	```

and the primitive shapes of the form:
	```ocaml
	let box v w l h =
	 fun v' ->
	  -.min
	      (min
	         ((w /. 2.0) -. abs_float (v'.x -. v.x))
	         ((h /. 2.0) -. abs_float (v'.y -. v.y)))
	      ((l /. 2.0) -. abs_float (v'.z -. v.z))

	let sphere v radius =
	 fun v' ->
	  pow2 radius -. pow2 (v'.x -. v.x) -. pow2 (v'.y -. v.y) -. pow2 (v'.z -. v.z)

	```

The synthesis problem is complicated by the parameters of the primitives, not the tree's depth or branching. The main
question is whether we can extract the components of a complex shape with eigen decomposition or similar methods. We
need to find a parameter agnostic way to synthesize the tree, the parameters can be optimized afterwards in a second
pass, or maybe in an alternating pattern, going between tree synthesis and parameter optimization.

## Problem Decomposition

- Synthesize FRep tree from a point cloud
	- How to measure accuracy of a solution
	- How to ensure solution doesn't get stuck in local minima
	- How to ensure that the solution will tend toward a 'good' solution
	- What is a 'good' solution? What heuristics will tend toward it?
	- How do we decide position for added primitives
	- Am I solving the mesh compression problem, or the point-cloud reconstruction problem?


## Possible Approaches
- Spectral methods with separate parameter optimization
- Can I leverage projections?
- Can I leverage continuity attributes of FRep functions? *
