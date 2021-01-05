#!/bin/bash
{
    ADPEVENTLOG() {
        megacli -AdpEventLog -GetLatest 100 -f "$HOME"/megacli-AdpEventLog.log -aALL
        echo "Log file located in: $HOME/megacli-AdpEventLog.log"
    }
    export -f ADPEVENTLOG


    ### ---------------------------------------------------------------- ###
    ##### Check for root. If not, executing as sudo.
    if [ $EUID -eq 0 ];
        then ADPEVENTLOG;
        else SUADPEVENTLOG=$(declare -f ADPEVENTLOG);
            sudo bash -c "$SUADPEVENTLOG; ADPEVENTLOG";
    fi
}