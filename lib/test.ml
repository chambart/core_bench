open Core.Std

module Id : Unique_id.Id = Unique_id.Int(Unit)
module Basic_test = struct
  type t = {
    test_id : Id.t;
    name    : string;
    f       : unit -> unit;
  } with fields

  let create ~name f =
    { name; f; test_id = Id.create () }

  let make_filename t =
    let name = String.tr ~target:' ' ~replacement:'-' t.name in
    name ^ ".txt"
end

type t = {
  name : string;
  tests: Basic_test.t list
} with fields

let create ~name bm = {
  name;
  tests = [Basic_test.create ~name bm];
}

let create_indexed ~name ~args bm = {
  name;
  tests = List.map args ~f:(fun n ->
    let name = name ^ ":" ^ (Int.to_string n) in
    { Basic_test. name = name; f = Staged.unstage (bm n); test_id = Id.create () })
}



