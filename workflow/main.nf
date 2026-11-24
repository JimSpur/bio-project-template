#!/usr/bin/env nextflow

/*
* Use echo to print 'Hello World!' to a file
*/

/*
 * Pipeline parameters
 */
params {
    input: String = 'Hello World'
    outputDir: Path = 'results/nextflow/helloworld'
}

process sayHello {

    input:
    val greeting

    output:
    path 'hello_process_1.txt'

    script:
    """
    echo '${greeting}' > hello_process_1.txt
    """
}

/*
 * Use a text replacement tool to convert the greeting to uppercase
 */
process convertToUpper {

    input:
    path 'hello_process_1.txt'

    output:
    path 'hello_process_2.txt'

    script:
    """
    cat 'hello_process_1.txt' | tr '[:lower:]' '[:upper:]' > hello_process_2.txt
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
        path { "${params.outputDir}" }
        mode 'copy'
    }
    second_output {
        path { "${params.outputDir}" }
        mode 'copy'
    }
}