import laurent;
import std.stdio;
import std.range;
import std.typecons;
import std.algorithm;

void main() {
	immutable Tuple!(double, int) a = tuple(1.0,0);
	immutable Tuple!(double, int) b = tuple(1.0,1);
	immutable Tuple!(double, int) c = tuple(2.0,0);
	immutable Tuple!(double, int) d = tuple(0.5,1);

	immutable Tuple!(double, int)[] ab = [a, b]; 
	immutable Tuple!(double, int)[] cd = [c, d]; 

    LaurentPolynomial!ab p1;
    LaurentPolynomial!cd p2;

    add!(p1,p2) p3;

	writeln(p3.data);

}