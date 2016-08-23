#!/bin/bash 

script_run()
{
    bandit_log "Setting up locales..."

    bandit_mkdir /usr/lib/locale
    for lang in ${PHY_LANG[*]}
    do
	bandit_msg "...${lang}..."
	localedef -i ${lang%%\.*} -f ${lang##*\.} /usr/lib/locale/${lang}
    done
}

