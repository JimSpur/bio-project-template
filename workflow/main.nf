#!/usr/bin/env nextflow

/*
* Use echo to print 'Hello World!' to a file
* Set the following keys in nextflow.config:

params {
    input = 'Hello World'
}

outputDir = "results/nextflow/"
*/

/*
 * Pipeline parameters
 */
params {
    input: String
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
    cat 'input_file_1' | tr '[:lower:]' '[:upper:]' > hello_process_2.txt
    """
}

workflow {

    main:
    // emit a greeting
    sayHello(params.input)
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