import scripts.utils.paths as paths
import scripts.utils.utils as utils
import scripts.generate.mc as mc


def gen_state():
    fields: dict[str, str] = utils.read_json(f"{paths.DATA}/state.json")

    variables = "\n".join(
        [f"\t(:initialized)\n\tprivate var {k} as {t};" for k, t in fields.items()]
    )
    load = mc.gen_func(
        "load",
        [
            "\n".join(
                [
                    f'\t\t{k} = Utils.getGameStateProperty("{k}") as {t};'
                    for k, t in fields.items()
                ] + ["\n\t\treturn self;"]
            )
        ],
        "",
        "GameState",
    )
    gets = [
        mc.gen_func(
            f"get{utils.capitalize(k)}",
            [f"\t\treturn {k};"],
            "",
            t,
        )
        for k, t in fields.items()
    ]
    sets = [
        mc.gen_func(
            f"set{utils.capitalize(k)}",
            [f'\t\t{k} = v;\n\t\tUtils.setGameStateProperty("{k}", v);'],
            f"v as {t}",
            "Void",
        )
        for k, t in fields.items()
    ]

    #  create class GameState around
    cls = mc.gen_class("GameState", [variables, load] + gets + sets)
    mod = mc.gen_mod("Generated", [cls])
    utils.write_file(f"{paths.SOURCE}/GameState.mc", mod)
