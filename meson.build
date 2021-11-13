project('idjit', ['c', 'd'])

run_command('dub', 'run', 'lumarsh', '--', './setup.lua', 'dmd')
run_command('dub', 'run', 'lumarsh', '--', './setup.lua', 'mir')

cmake = import('cmake')

mir_dep = subproject('mir').get_variable('mir_dep')
dmd_dep = subproject('dmd').get_variable('dmd_dep')

src = [
    'source/mir.d',
    'source/idjit/example.d'
]

idjit_dep = declare_dependency(
    sources: src,
    dependencies: [mir_dep, dmd_dep],
    include_directories: include_directories('source'),
)

idjit_example = executable(
    'example',
    dependencies: idjit_dep,
    d_module_versions: ['MARS', 'NoMain', 'GC', 'NoBackend', 'CallbackAPI', 'DMDLIB'],
    d_args: [
        '-J'+meson.source_root()+'/subprojects/dmd',
        '-J'+meson.source_root()+'/subprojects/dmd/src/dmd/res',
        '-J'+meson.source_root()+'/subprojects/dmd/generated/dub',
    ]
)