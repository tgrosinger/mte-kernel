module Row = struct
  type t = string list

  let width = List.length
end

module Unnormalized = struct
  type t = {
    header: Row.t option;
    body: Row.t list;
    alignments: Alignment.t option list;
  }

  let create ~header ~body ~alignments = { header; body; alignments }

  let header table = table.header
  let body table = table.body
  let alignments table = table.alignments
end

module Normalized = struct
  type t = {
    header: Row.t option;
    body: Row.t list;
    alignments: Alignment.t option list;
    width: int;
  }

  let create ~header ~body ~alignments =
    match header with
    | Some header_row ->
      let width = Row.width header_row in
      assert (width > 0);
      assert (List.for_all (fun row -> Row.width row = width) body);
      assert (List.length alignments = width);
      { header; body; alignments; width }
    | None ->
      (* When there is no header, body must have at least one row *)
      assert (List.length body > 0);
      let width = Row.width @@ List.hd body in
      assert (width > 0);
      assert (List.for_all (fun row -> Row.width row = width) body);
      assert (List.length alignments = width);
      { header; body; alignments; width }

  let header table = table.header
  let body table = table.body
  let alignments table = table.alignments
  let width table = table.width
end

include Unnormalized
