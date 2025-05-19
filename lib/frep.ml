type point = { x : float; y : float; z : float }
type frep = point -> float
type primitive = ..
type primitive += Sphere of frep

type op =
  | Neg of obj
  | Metamorphize of obj * obj * float
  | Union of obj * obj
  | Intersection of obj * obj
  | Subtraction of obj * obj

and obj = Prim of frep | Construct of op

let pow2 = (Fun.flip Float.pow) 2.0

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

let show (p : primitive) = match p with Sphere _ -> "Sphere" | _ -> "Unknown"
let simple = Prim (sphere { x = 0.; y = 0.; z = 0. } 3.0)

let rec eval p = function
  | Prim f -> f p
  | Construct (Neg f) -> -.eval p f
  | Construct (Union (left, right)) ->
      let f_1 = eval p left in
      let f_2 = eval p right in
      f_1 +. f_2 +. Float.sqrt (pow2 f_1 +. pow2 f_2)
  | Construct (Intersection (left, right)) ->
      let f_1 = eval p left in
      let f_2 = eval p right in
      f_1 +. f_2 -. Float.sqrt (pow2 f_1 +. pow2 f_2)
  | Construct (Subtraction (left, right)) ->
      eval p (Construct (Intersection (left, Construct (Neg right))))
  | Construct (Metamorphize (_from, _to', _progress)) ->
      failwith "Unimplemented"

(* this is centered around the origin for simplicity *)
(* granularity is points per unit length *)
let quantize_bounding_box ?(g = 3) l w h : point array =
  let ol = float_of_int l /. 2. in
  let ow = float_of_int w /. 2. in
  let oh = float_of_int h /. 2. in
  let quant = 1.0 /. float_of_int g in
  ( Array.init ((g * l) + 1) @@ fun i ->
    Array.init ((g * w) + 1) @@ fun j ->
    Array.init ((g * h) + 1) @@ fun k ->
    {
      x = (float_of_int i *. quant) -. ol;
      y = (float_of_int j *. quant) -. ow;
      z = (float_of_int k *. quant) -. oh;
    } )
  |> Array.fold_left (fun acc ar -> Array.append acc ar) [||]
  |> Array.fold_left (fun acc ar -> Array.append acc ar) [||]

let write_points (ps : point array) filename =
  Out_channel.with_open_text filename @@ fun oc ->
  ps
  |> Array.iter @@ fun point ->
     output_string oc @@ Printf.sprintf "%f %f %f\n" point.x point.y point.z

let get_prim_surface ?(epsilon = 0.001) (shape_at : frep) (box : point array) =
  box |> Array.to_list
  |> ( List.filter @@ fun point ->
       let d = abs_float @@ shape_at point in
       d < epsilon )
  |> Array.of_list

let get_surface ?(epsilon = 0.001) (shape_at : obj) (box : point array) =
  box |> Array.to_list
  |> ( List.filter @@ fun point ->
       let d = abs_float @@ eval point shape_at in
       d < epsilon )
  |> Array.of_list
