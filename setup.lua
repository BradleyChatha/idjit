if #LUMARSH_ARGS > 0 and LUMARSH_ARGS[1] == 'dmd' then
    sh:cp('dmd.meson.build', 'subprojects/dmd/meson.build')
    sh.fs.chdir('subprojects/dmd')
    sh:dub('build') -- Generates some files we need
elseif #LUMARSH_ARGS > 0 and LUMARSH_ARGS[1] == 'mir' then
    if sh.proc.executeShell('dstep', {}).status ~= 0 then
        error('Please install dstep into your PATH')
    end

    -- Was struggling to get the built-in CMake plugin to actually build MIR,
    -- so we'll Mesonify it as well.
    sh:cp('mir.meson.build', 'subprojects/mir/meson.build')

    sh.fs.chdir('subprojects/mir')
    sh:dstep('mir.h')

    -- Fixes va_list missing and htab_hash_t
    local fixed = sh.fs.readString('mir.d')
    fixed = 'import core.stdc.stdarg;\n'..fixed
    fixed = 'alias htab_hash_t = uint;\n'..fixed
    sh.fs.write('mir_fixed.d', fixed)

    -- Check that it compiles
    sh:dmd('mir_fixed.d', '-c')

    -- Copy it over
    sh:cp('mir_fixed.d', '../../source/mir.d')
end