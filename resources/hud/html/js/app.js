(() => {

    HudManager = {};

    HudManager.TimerActive = false
    HudManager.ProgBar
    HudManager.Minimal = false

    HudManager.CurrentTask

    HudManager.CurrentValues = {
        health: 0,
        armor: 0,
        food: 0,
        water: 0
    }

    HudManager.ToggleHud = function(state) {
        if (state) {
            $('.hud-wrapper').fadeIn(300)
        } else {
            $('.hud-wrapper').fadeOut(300)
        }
    }

    HudManager.UpdateAllValues = function(data) {
        if (data.health != null) {

            if (HudManager.Minimal) {
                let margin = ( (data.health / 100) * 3)

                $('.health').css('width', margin + 'vh')
                $('.health > p').html(data.health + '%')
            } else {
                if (data.health == -100){
                    $('.health').css('width', 0 + '%')
                    $('.health > p').html(0 + '%')
                } else if(data.dead){
                    $('.health').css('width', 0 + '%')
                    $('.health > p').html(0 + '%')
                } else{
                    $('.health').css('width', data.health + '%')
                    $('.health > p').html(data.health + '%')
                } 
            }

            HudManager.CurrentValues['health'] = data.health
        }

        if (data.armor != null) {
            $('.armor').css('width', data.armor + '%')
            $('.armor > p').html(data.armor + '%')

            HudManager.CurrentValues['armor'] = data.armor
        }

        if (data.water != null) {
            $('.water').css('width', data.water + '%')
            $('.water > p').html(data.water + '%')

            HudManager.CurrentValues['water'] = data.water
        }

        if (data.food != null) {
            $('.food').css('width', data.food + '%')
            $('.food > p').html(data.food + '%')

            HudManager.CurrentValues['food'] = data.food
        }
    }

    HudManager.UpdateSingleValue = function(index, value) {
        if ( (index != null && index != undefined) && (value != null && index != undefined) ) {
            $('.hud-item-bar.' + index).css('width', value + '%')
            $('.hud-item-bar.' + index + ' > p').html(value + '%')

            HudManager.CurrentValues[index] = value
        }
    }

    HudManager.ToggleSurvival = function(state) {
        if (state) {
            $('#foodNoti').fadeIn(500)
            $('#waterNoti').fadeIn(500)
        } else {
            $('#foodNoti').fadeOut(500)
            $('#waterNoti').fadeOut(500)
        }
    }

    HudManager.ToggleBleed = function(state, mutli) {
        if (state) {
            $('#bleedingNoti').fadeIn(500)
            $('#bleedState').html(mutli)
        } else {
            $('#bleedingNoti').fadeOut(500)
        }
    }

    HudManager.ToggleStress = function (state, mutli) {
        if (state) {
            $('#stressNoti').fadeIn(500)
            $('#secondText').html(mutli)
        } else {
            $('#stressNoti').fadeOut(500)
        }
    }

    HudManager.BeginProgress = function(tId, text, time) {
        let timer = time
        HudManager.TimerActive = true
        HudManager.CurrentTask = tId

        $('#progressBar').fadeIn(500)
        $('#progText').html(text)
        $('#progressTimer').html('' + timer + 's')

        setTimeout(() => {
            if (HudManager.TimerActive) {
                HudManager.ProgBar = setInterval(() => {
                    timer = timer - 1

                    $('#progressTimer').html('' + timer + 's')

                    if (timer < 1) {
                        clearInterval(HudManager.ProgBar)
                        $.post('https://hud/progbarSucccess', JSON.stringify({ taskId: HudManager.CurrentTask }))
                        $('#progressBar').fadeOut(500)
                    }

                }, 1000)
            }
        }, 500)

    }

    HudManager.CancelProgress = function() {
        if (HudManager.TimerActive) {
            HudManager.TimerActive = false
            clearInterval(HudManager.ProgBar)
            $.post('https://hud/progbarCancel', JSON.stringify({ taskId: HudManager.CurrentTask }))

            HudManager.CurrentTask = ''

            $('#progText').html('cancelled')
            $('#progressTimer').html('-')

            setTimeout(() => {
                $('#progressBar').fadeOut(500)
            }, 1500)
        }
    }

    // HudManager.MinimaliseHud = function() {
    //     HudManager.Minimal = true
    //     $('.hud-item-bar-main > p').fadeOut(1000)

    //     $('.health, .armor, .food, .water').animate({ opacity: '0%', width: '3vh' }, 1000, (() => {
    //         $('.hud-icon').animate({ right: '0vh' }, 1000, (() => {
    //             $('.hud-item').animate({ width: '3vh' }, 1000, (() => {
    //                 $('.health, .armor, .food, .water').animate({ 'opacity': '100%' }, 1000)
    //             }))
    //         }))
    //     }))
    // }

    // HudManager.BiggerHud = function() {
    //     HudManager.Minimal = false
    //     $('.hud-item-bar-main > p').fadeIn(1000)

    //     $('.hud-item').animate({ width: '23vh' }, 1000, (() => {
    //         $('.hud-icon').animate({ left: '0vh' }, 1000, (() => {
    //             $('.health, .armor, .food, .water').animate({ 'opacity': '100%' }, 1000, (() => {
    //                 $('.hud-item-bar-main > p').fadeIn(1000)
    //             }))
    //         }))
    //     }))
    // }

    window.onload = function(e) {
        // HudManager.ToggleHud(false)


        window.addEventListener('message', function (event) {
            switch (event.data.action) {
                case "position":
                    let up = event.data.up;
                    let left = event.data.left;
                    if (up == "default") {
                        break
                    } else{ 
                        document.getElementById("drag-fart").style.top = up;
                        document.getElementById("drag-fart").style.left = left;
                    }
                    console.log(up, left);
                    break
                case "toggle":
                    HudManager.ToggleHud(event.data.state);
                    break;
                case "updateall":
                    HudManager.UpdateAllValues(event.data.values);
                    break;
                case 'updatesingle':
                    HudManager.UpdateSingleValue(event.data.index, event.data.value);
                    break;
                case 'progbar':
                    HudManager.BeginProgress(event.data.id, event.data.text, event.data.time);
                    break;
                case 'togglebleed':
                    HudManager.ToggleBleed(event.data.state, event.data.multi);
                    break;
                case 'togglestress':
                    HudManager.ToggleStress(event.data.state, event.data.multi);
                    break;
                case 'togglesurvival':
                    HudManager.ToggleSurvival(event.data.state);
                    break;
                case 'cancelprog':
                    HudManager.CancelProgress();
                    break;
                case 'toggleMinimal':
                    if (event.data.state) {
                        HudManager.MinimaliseHud()
                    } else {
                        HudManager.BiggerHud()
                    }
                    break;
            }
        })

    }

})();

$(document).keydown(function(e) {
    if (e.key === "Escape") { 
        let up = document.getElementById("drag-fart").style.top
        let left = document.getElementById("drag-fart").style.left
        $.post("https://hud/exit", JSON.stringify({
            up: up,
            left: left
        }));
    }
});

dragElement(document.getElementById("drag-fart"));

function dragElement(elmnt) {
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
  if (document.getElementById(elmnt.id + "header")) {
    // if present, the header is where you move the DIV from:
    document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
  } else {
    // otherwise, move the DIV from anywhere inside the DIV:
    elmnt.onmousedown = dragMouseDown;
  }

  function dragMouseDown(e) {
    e = e || window.event;
    e.preventDefault();
    // get the mouse cursor position at startup:
    pos3 = e.clientX;
    pos4 = e.clientY;
    document.onmouseup = closeDragElement;
    // call a function whenever the cursor moves:
    document.onmousemove = elementDrag;
  }

  function elementDrag(e) {
    e = e || window.event;
    e.preventDefault();
    // calculate the new cursor position:
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    // set the element's new position:
    elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
    elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
    console.log(elmnt.style.top);
    console.log(elmnt.style.left);
  }

  function closeDragElement() {
    // stop moving when mouse button is released:
    document.onmouseup = null;
    document.onmousemove = null;
  }
}
