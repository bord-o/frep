open Frep

let () = print_endline "FREP"

let () =
  let sp1 = sphere { x = 0.; y = 0.; z = 0. } 1.0 in
  let box = quantize_bounding_box ~g:15 3 3 3 in
  let s = get_surface ~epsilon:0.1 sp1 box in
  write_points s "./sphere1.xyz"
