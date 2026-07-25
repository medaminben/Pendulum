# Lightweight INI helpers for optional third-party path configuration.
# Place files under cmake/configs/ (gitignored env overrides).

function(read_from_ini_file)
    set(options)
    set(single_value_args CONF_NAME POSTFIX)
    set(list_args KEYS)
    cmake_parse_arguments(PARSE_ARGV 0 ini
        "${options}" "${single_value_args}" "${list_args}")

    foreach(arg IN LISTS ini_UNPARSED_ARGUMENTS)
        prompt(WARNING "unparsed argument: ${arg}")
    endforeach()

    if(NOT DEFINED ini_CONF_NAME)
        prompt(WARNING "config file name not defined")
        return()
    endif()

    if(NOT DEFINED ini_POSTFIX)
        set(postfix "INI_VALUE")
    else()
        set(postfix ${ini_POSTFIX})
    endif()

    if(NOT EXISTS "${ini_CONF_NAME}")
        prompt(WARNING "INI file not found: ${ini_CONF_NAME}")
        return()
    endif()

    file(READ ${ini_CONF_NAME} config_file_text_stream)
    string(REPLACE "\n" ";" config_file_lines "${config_file_text_stream}")

    if(NOT DEFINED ini_KEYS)
        foreach(line ${config_file_lines})
            if(${line} MATCHES "=")
                string(REGEX REPLACE "^(.*)=" "" value "${line}")
                string(REPLACE "=${value}" "" key "${line}")
                set(${key}_${postfix} ${value} PARENT_SCOPE)
            endif()
        endforeach()
    else()
        foreach(key IN LISTS ini_KEYS)
            foreach(line ${config_file_lines})
                if(${line} MATCHES "^${key}=")
                    string(REPLACE "${key}=" "" value "${line}")
                    set(${key}_${postfix} ${value} PARENT_SCOPE)
                endif()
            endforeach()
        endforeach()
    endif()
endfunction()
