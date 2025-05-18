type point = { x : float; y : float; z : float }
type frep = point -> float
type primitive = ..

type op = Metamorphize of obj * obj * float
and obj = Prim of frep | Construct of op

let pow2 = (Fun.flip Float.pow) 2.0

type primitive += Sphere of frep

let sphere v radius =
 fun v' ->
  Float.neg
    (pow2 (v'.x -. v.x)
    +. pow2 (v'.y -. v.y)
    +. pow2 (v'.z -. v.z)
    -. pow2 radius)

let show (p : primitive) = match p with Sphere _ -> "Sphere" | _ -> "Unknown"
let simple = Prim (sphere { x = 0.; y = 0.; z = 0. } 3.0)

let morph =
  Construct
    (Metamorphize
       ( Prim (sphere { x = 0.; y = 0.; z = 0. } 3.0),
         Prim (sphere { x = 10.; y = 0.; z = 0. } 1.0),
         0.5 ))

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

let get_surface ?(epsilon = 0.001) (shape_at : frep) (box : point array) =
  box |> Array.to_list
  |> ( List.filter @@ fun point ->
       Float.neg epsilon < shape_at point && shape_at point < epsilon )
  |> Array.of_list
