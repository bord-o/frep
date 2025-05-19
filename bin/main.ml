open Frep

let () = print_endline "FREP"

let () =
  let bound = quantize_bounding_box ~g:20 3 3 3 in

  let sp1 = Prim (sphere { x = 0.3; y = 0.; z = 0. } 1.0) in
  let sp2 = Prim (sphere { x = -0.3; y = 0.; z = 0. } 1.0) in

  let construction = Construct (Intersection (sp1, sp2)) in
  let construction2 = Construct (Union (sp1, sp2)) in
  let construction3 = Construct (Subtraction (sp1, sp2)) in

  (* let construction = Construction () in *)
  (* () *)
  let construction_surf = get_surface ~epsilon:0.01 construction bound in
  let construction_surf2 = get_surface ~epsilon:0.01 construction2 bound in
  let construction_surf3 = get_surface ~epsilon:0.01 construction3 bound in

  (* let box1 = box { x = 0.; y = 0.; z = 0. } 1. 1. 1. in *)
  (* let box1_surf = get_prim_surface ~epsilon:0.01 box1 bound in *)
  write_points construction_surf3 "./test/construction3.xyz"
(* write_points box1_surf "./test/box1.xyz" *)
