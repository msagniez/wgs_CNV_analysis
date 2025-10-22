// Import modules
include { MINIMAP2_ALIGN         } from '../../../modules/local/minimap2/main.nf'         // minimap2 alignment
include { SAMTOOLS_TOBAM         } from '../../../modules/local/samtools/main.nf'         // Convert SAM to BAM
include { SAMTOOLS_SORT          } from '../../../modules/local/samtools/main.nf'         // Sort BAM
include { SAMTOOLS_INDEX         } from '../../../modules/local/samtools/main.nf'         // Index BAM
include { CRAMINO_STATS          } from '../../../modules/local/cramino/main.nf'          // Coverage stats

// Define the main workflow
workflow MAPPING {
    take:
    ch_samplesheet

    main:
    ch_versions = Channel.empty() // For collecting version info


    // Align reads to reference genome
    MINIMAP2_ALIGN (ch_samplesheet)
    
    // Convert SAM to BAM
    SAMTOOLS_TOBAM(MINIMAP2_ALIGN.out.sam)

    // Sort and index BAM
    SAMTOOLS_SORT(SAMTOOLS_TOBAM.out.bamfile)
    SAMTOOLS_INDEX(SAMTOOLS_SORT.out.sortedbam)
    
    // Compute coverage stats
    CRAMINO_STATS(SAMTOOLS_INDEX.out.bamfile_index)

}