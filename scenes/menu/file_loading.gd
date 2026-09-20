extends MenuWindow

func load_animation(txt:String,time:float=2):
    $Label.text=txt
    await open()
    var tween := create_tween()
    match randi_range(0,2):
        0:
            tween.set_trans(Tween.TRANS_CIRC)
        1:
            tween.set_trans(Tween.TRANS_EXPO)
        2:
            tween.set_trans(Tween.TRANS_SINE)
    AudioPlayer.play_game_sfx(AudioPlayer.hp_loading)
    tween.tween_property($ProgressBar,"value",100,time)
    await tween.finished
    await begone()