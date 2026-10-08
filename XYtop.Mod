MODULE XYtop;  (** the XY plane of these games, in the rows a viewer shows, with their keys under them *)

(* The games were drawn for a screen of 800 x 600, near y = 0. The XYplane of ETH Oberon is a plane of
	the size of the screen, and a viewer shows its top rows. XYtop is XYplane with the rows of a game
	moved to the top H rows of the plane (Rows, Area set them), so that a viewer of H pixels or more shows
	them; under them it writes the lines of Help (the keys of the game), in a font of 5 x 7 dots (the
	misc-fixed 5x7 of X11, public domain). The games import it in place of XYplane (XYplane := XYtop,
	X := XYtop); XYplane is not changed. *)

IMPORT XYplane;

CONST
	erase* = XYplane.erase; draw* = XYplane.draw;
	MaxLines = 4; LineH = 9;  (* help lines, their height in dots *)
	First = 32; Last = 126;  (* the characters of the font: 7 rows (top first) of 5 dots each, ORD("0") + bits *)
	F0 = "00000004444040:::00000:O:O:00>D>5>0@B48B2008D8D:04440000488884084444800:4>4:0044O4400000648000N0000000<<00248@004::::40";
	F1 = "4<444>0<B248N0N2<2B<04<DN440N@L2B<0<@LBB<0N244880<B<BB<0<BB>2<00<<0<<00<<0<8@024842000N0N0008424804:24040<BFF@<0<BBNBB0";
	F2 = "LBLBBL0<B@@B<0LBBBBL0N@L@@N0N@L@@@0<B@FB>0BBNBBB0>4444>02222B<0BDHHDB0@@@@@N0BNNBBB0BJJFFB0<BBBB<0LBBL@@0<BBBJ<2LBBLDB0";
	F3 = "<B84B<0>444440BBBBB<0BBBB<<0BBBNNB0BB<<BB0:::4440N248@N0>8888>00@84200>2222>04:0000000000N0840000000>BF:0@@LBBL000<@@<0";
	F4 = "22>BB>000<FH<04:8L88000>B<@>@@LBBB040<44>020222:4@@DHDB0<4444>000DNBB000LBBB000<BB<000LBBL@00>BB>200LB@@000>H6L088L8860";
	F5 = "00BBB>000:::4000BBNN000B<<B000BB:4800N48N024<442044444408464480:D00000";

VAR
	W*, H*: INTEGER;  (** the size of the plane the games see *)
	off, lo: INTEGER;  (* their row lo is row off of XYplane *)
	help: ARRAY MaxLines, 80 OF CHAR; lines: INTEGER;
	font: ARRAY (Last - First + 1) * 7 + 1 OF CHAR; fn: INTEGER;

PROCEDURE Append(s: ARRAY OF CHAR);
VAR i: INTEGER;
BEGIN i := 0; WHILE s[i] # 0X DO font[fn] := s[i]; INC(fn); INC(i) END
END Append;

(* the character ch with its top left corner at x, y of XYplane *)
PROCEDURE Char(ch: CHAR; x, y: INTEGER);
VAR r, c, bits, k: INTEGER;
BEGIN
	IF (ch >= CHR(First)) & (ch <= CHR(Last)) THEN
		k := (ORD(ch) - First) * 7; r := 0;
		WHILE r < 7 DO
			bits := ORD(font[k + r]) - ORD("0"); c := 0;
			WHILE c < 5 DO
				IF ODD(bits DIV 16) THEN XYplane.Dot(x + c, y - r, draw) END;
				bits := bits * 2 MOD 32; INC(c)
			END;
			INC(r)
		END
	END
END Char;

PROCEDURE ShowHelp;  (* the help lines under the rows of the game *)
VAR i, j, y: INTEGER;
BEGIN
	i := 0;
	WHILE i < lines DO
		y := off - 4 - i * LineH; j := 0;
		WHILE (j < LEN(help[i])) & (help[i][j] # 0X) DO Char(help[i][j], 10 + 5 * j, y); INC(j) END;
		INC(i)
	END
END ShowHelp;

(** the game draws in rows low .. high-1 (call before Open); the help goes under them *)
PROCEDURE Area*(low, high: INTEGER);
BEGIN
	lo := low; H := high - low;
	IF H > XYplane.H - MaxLines * LineH - 8 THEN H := XYplane.H - MaxLines * LineH - 8 END;
	off := XYplane.H - H; lines := 0
END Area;

(** the game draws in rows 0 .. n-1 *)
PROCEDURE Rows*(n: INTEGER);
BEGIN Area(0, n)
END Rows;

(** a line of help under the game: its keys (call after Open; up to 4 lines) *)
PROCEDURE Help*(s: ARRAY OF CHAR);
BEGIN
	IF lines < MaxLines THEN COPY(s, help[lines]); INC(lines); ShowHelp END
END Help;

PROCEDURE Open*;
BEGIN XYplane.Open; ShowHelp
END Open;

PROCEDURE Clear*;
BEGIN XYplane.Clear; ShowHelp
END Clear;

PROCEDURE Dot*(x, y, mode: INTEGER);
BEGIN
	DEC(y, lo);
	IF (y >= 0) & (y < H) THEN XYplane.Dot(x, y + off, mode) END
END Dot;

PROCEDURE IsDot*(x, y: INTEGER): BOOLEAN;
BEGIN DEC(y, lo); RETURN (y >= 0) & (y < H) & XYplane.IsDot(x, y + off)
END IsDot;

PROCEDURE Key*(): CHAR;
BEGIN RETURN XYplane.Key()
END Key;

BEGIN
	W := XYplane.W; fn := 0;
	Append(F0);
	Append(F1);
	Append(F2);
	Append(F3);
	Append(F4);
	Append(F5);
	font[fn] := 0X;
	Rows(450)
END XYtop.
