//.pragma library

function hasFocusChildren(elem)
{
    var r = false;

    for (var i = 0; i < elem.children.length; ++i)
        r = r || elem.focus || hasFocusChildren(elem.children[i]);

    return r;
}

function treeDump(elem, pfx, last)
{
    if (pfx === undefined)
        pfx = "";

    console.log(elem.focus ? "F" : "_",
                elem.activeFocus ? "A" : "_",
                pfx,
                last ? "`" : "+",
                elem, elem.width, elem.height);

    pfx = pfx + ((last || !pfx) ? "  " : " |");

    if (elem.children.length && !hasFocusChildren(elem)) {
        console.log(" ", " ", pfx, "(no focusable children)");
    } else {
        for (var i = 0; i < elem.children.length; ++i)
            treeDump(elem.children[i], pfx, i == elem.children.length - 1);
    }
}
