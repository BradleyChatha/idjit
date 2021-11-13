module idjit.example;

import std, dmd.frontend, mir;

// Please see: https://github.com/vnmakarov/mir/blob/master/MIR.md
// Also please see: https://github.com/vnmakarov/mir/blob/5dbe37c920c92ef0975d49aafe0e183f26018e42/mir-tests/run-test.c
void main()
{
    MIR_context_t ctx = _MIR_init();
    initDMD();

    import core.stdc.stdio : printf;
    MIR_load_external(ctx, "printf", &printf);
    MIR_scan_string(ctx, `
m_example:  module
            export example

            import printf

p_printf:   proto p:fmt, i32:v
format:     string "The result is: %d\n"

example:    func i32, i32:A, i32:B
            local i64:RESULT
            add RESULT, A, B
            call p_printf, printf, format, RESULT
            ret 0
            endfunc

            endmodule
    `);

    MIR_module_t mod = MIR_get_module_list(ctx).head;
    MIR_load_module(ctx, mod);
    MIR_link(ctx, &MIR_set_interp_interface, null);
    MIR_item_t item = mod.items.head;
    while(item)
    {
        scope(exit) item = item.item_link.next;

        if(item.item_type == MIR_item_type_t.MIR_func_item
        && item.u.func.name.fromStringz == "example")
        {
            MIR_val_t val;
            MIR_val_t a; a.i = 100;
            MIR_val_t b; b.i = 200;
            MIR_interp(ctx, item, &val, 2, a, b);
            return;
        }
    }
    writeln("Couldn't find example function?");
}