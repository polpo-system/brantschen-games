MODULE XYtop;  (** the XY plane of these games, in the rows a viewer shows *)

(* The games were drawn for a screen of 800 x 600, near y = 0. The XYplane of ETH Oberon is a plane of
	the size of the screen, and a viewer shows its top rows. XYtop is XYplane with the games' rows
	0 .. H-1 moved to the top H rows of the plane, so that a viewer of H pixels or more shows them.
	The games import it in place of XYplane (XYplane := XYtop, X := XYtop); XYplane is not changed. *)

IMPORT XYplane;

CONST
	erase* = XYplane.erase; draw* = XYplane.draw;
	Rows = 400;  (* the games draw below y = 400 *)

VAR
	W*, H*: INTEGER;  (** the size of the plane the games see *)
	off: INTEGER;  (* their row 0 is row off of XYplane *)

PROCEDURE Open*;
BEGIN XYplane.Open
END Open;

PROCEDURE Clear*;
BEGIN XYplane.Clear
END Clear;

PROCEDURE Dot*(x, y, mode: INTEGER);
BEGIN
	IF (y >= 0) & (y < H) THEN XYplane.Dot(x, y + off, mode) END
END Dot;

PROCEDURE IsDot*(x, y: INTEGER): BOOLEAN;
BEGIN RETURN (y >= 0) & (y < H) & XYplane.IsDot(x, y + off)
END IsDot;

PROCEDURE Key*(): CHAR;
BEGIN RETURN XYplane.Key()
END Key;

BEGIN
	W := XYplane.W; H := Rows; IF H > XYplane.H THEN H := XYplane.H END;
	off := XYplane.H - H
END XYtop.
