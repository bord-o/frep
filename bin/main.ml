open Frep

let () = print_endline "FREP"

let () =
  let bound = quantize_bounding_box ~g:20 4 4 4 in

  let sp1 = Prim (sphere { x = 1.; y = 0.; z = 0. } 0.5) in
  (* let sp2 = Prim (sphere { x = -0.3; y = 0.; z = 0. } 1.0) in *)
  let box1 = Prim (box { x = -1.; y = 0.; z = 0. } 0.5 0.5 0.5) in

  (* let construction = Construct (Intersection (sp1, sp2)) in *)
  (* let construction2 = Construct (Union (sp1, sp2)) in *)
  (* let construction3 = Construct (Subtraction (sp1, sp2)) in *)

  (* This is sick *)
  let morph1 = Construct (Metamorphosis (box1, sp1, 0.0)) in

  (* let construction = Construction () in *)
  (* () *)
  (* let construction_surf = get_surface ~epsilon:0.01 construction bound in *)
  (* let construction_surf2 = get_surface ~epsilon:0.01 construction2 bound in *)
  (* let construction_surf3 = get_surface ~epsilon:0.01 construction3 bound in *)
  let morph_surf1 = get_surface ~epsilon:0.01 morph1 bound in

  write_points morph_surf1 "./test/morph1.xyz"
(* write_points box1_surf "./test/box1.xyz" *)
