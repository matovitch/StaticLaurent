import std.array;
import std.range;
import std.traits;
import std.typecons;
import std.algorithm;

auto myCartesianProduct(R1, R2)(R1 range1, R2 range2)
{
    static if (isInfinite!R1 && isInfinite!R2)
    {
        static if (isForwardRange!R1 && isForwardRange!R2)
        {
            // This algorithm traverses the cartesian product by alternately
            // covering the right and bottom edges of an increasing square area
            // over the infinite table of combinations. This schedule allows us
            // to require only forward ranges.
            return zip(sequence!"n"(cast(size_t)0), range1.save, range2.save,
                       repeat(range1), repeat(range2))
                .map!(function(a) => chain(
                    zip(repeat(a[1]), take(a[4].save, a[0])),
                    zip(take(a[3].save, a[0]+1), repeat(a[2]))
                ))()
                .joiner();
        }
        else static assert(0, "cartesianProduct of infinite ranges requires "~
                              "forward ranges");
    }
    else static if (isInputRange!R2 && isForwardRange!R1 && !isInfinite!R1)
    {
        return joiner(map!((ElementType!R2 a) => zip(range1.save, cycle([a])))
                          (range2));
    }
    else static if (isInputRange!R1 && isForwardRange!R2 && !isInfinite!R2)
    {
        return joiner(map!((ElementType!R1 a) => zip(cycle([a]), range2.save))
                          (range1));
    }
    else static assert(0, "cartesianProduct involving finite ranges must "~
                          "have at least one finite forward range");
}

struct LaurentPolynomial(alias P)
{
    enum data = P;
}

template add(alias B, alias C)
{
    alias add = LaurentPolynomial!(
        map!(a => tuple(a[0][0] + a[1][0], a[0][1]))
        (
            filter!(a => (a[0][1] == a[1][1]))
            (
                myCartesianProduct(B.data, C.data)
            )
        )
    );
}