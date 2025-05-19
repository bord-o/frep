open Frep

let () = print_endline "FREP"

let () =
  let bound = quantize_bounding_box ~g:20 3 3 3 in

  let sp1 = sphere { x = 0.; y = 0.; z = 0. } 1.0 in
  let sp1_surf = get_prim_surface ~epsilon:0.01 sp1 bound in

  let box1 = box { x = 0.; y = 0.; z = 0. } 1. 1. 1. in
  let box1_surf = get_prim_surface ~epsilon:0.01 box1 bound in

  write_points sp1_surf "./test/sphere2.xyz";
  write_points box1_surf "./test/box1.xyz"
