extends PanelContainer

func setup_label(i:int)->void:
    var section:String="level_"+str(i)
    if ConfigManager.levels.get_value(section,"namedroped",false):
        var level_name=ConfigManager.levels.get_value(section,"name")
        $Label.text=" "+level_name+" "
    else:
        $Label.text=" ??? "
    show()