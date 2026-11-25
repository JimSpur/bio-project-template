#!/usr/bin/env nextflow

/*
* Use echo to print 'Hello World' to a file
* Default params set in nextflow.config
*/

/*
 * Pipeline parameters
 */
params {
    greeting: String
}

process sayHello {

    input:
    val greeting

    output:
    path 'hello_process_1.txt'

    script:
    """
    echo "${greeting}" > hello_process_1.txt
    """
}

/*
 * Use a text replacement tool to convert the greeting to uppercase
 */
process convertToUpper {

    input:
    path 'input_file_1'

    output:
    path 'hello_process_2.txt'

    script:
    """
    tr '[:lower:]' '[:upper:]' < 'input_file_1' > hello_process_2.txt
    """
}

workflow {

    main:
    // emit a greeting
    sayHello(params.greeting)
    // convert to uppercase
    convertToUpper(sayHello.out)

    publish:
    first_output = sayHello.out
    second_output = convertToUpper.out
}

output {
    first_output {
        path 'helloworld'
        mode 'copy'
    }
    second_output {
        path 'helloworld'
        mode 'copy'
    }
}
