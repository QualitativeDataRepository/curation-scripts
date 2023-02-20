# DESCRIPTION
# This script takes a .vtt script, removes timecodes, line numbers, and other machine-readable stuff
# It then goes line by line and merges lines that have the same speaker, inserting an empty line when speakers change
# Tested only with Zoom-generated .vtt
# Re-uses some code from Pablo Bernabeu: https://github.com/pablobernabeu/VTT-Transcription-App under CC-BY license

# USAGE
# Set the working directory to a folder in which you have .vtt files (the script will ignore everything else) and run everything. New files will have the same filenames as the original, replacing .vtt with _cleaned.txt

# LICENSE - MIT License  
# Copyright 2023 Qualitative Data Repository
#   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


library(stringr)

# Set directory here (yes, I know)
setwd("SET TO a DIRECTORY with .vtt FILES")


# Cleaning Functions ------------------------------------------------------


regexClean <- function (transcript) {
  transcript = str_replace_all(transcript, regex('^WEBVTT$', multiline = TRUE), '')
  transcript = str_replace_all(transcript, regex('^Kind: captions$', multiline = TRUE), '')
  transcript = str_replace_all(transcript,
                               regex('^Language: [[:alpha:]]*-[[:alpha:]]*$', multiline = TRUE),
                               '')
  
  # Remove long serial codes
  transcript = str_replace_all(
    transcript,
    regex(
      '^[[:alnum:]]*-[[:alnum:]]*-[[:alnum:]]*-[[:alnum:]]*-[[:alnum:]]*$',
      multiline = TRUE
    ),
    ''
  )
  
  # Remove ordinal numbering of utterances (single numbers in lines)
  transcript = str_replace_all(transcript, regex('^\\d*$', multiline = TRUE), '')
  
  # Remove timestamps in both formats (dot or comma at the end)
  transcript = str_replace_all(
    transcript,
    regex(
      '^\\d\\d:\\d\\d:\\d\\d\\.\\d\\d\\d --> \\d\\d:\\d\\d:\\d\\d\\.\\d\\d\\d$',
      multiline = TRUE
    ),
    ''
  )
  transcript = str_replace_all(
    transcript,
    regex(
      '^\\d\\d:\\d\\d:\\d\\d,\\d\\d\\d --> \\d\\d:\\d\\d:\\d\\d,\\d\\d\\d$',
      multiline = TRUE
    ),
    ''
  )
  
  return (transcript)
}


# Goes line-by-line to clean up speaker tags and concat lines by the same speaker
lineClean <- function(transcript) {
  lines <- stringi::stri_split_lines(transcript)
  text <- ""
  speaker <- ""
  lineText <- ""
  new_speaker <- ""
  for (line in lines[[1]]) {
    if (str_length(line) == 0) {
      next
    }
    print(line)
    
    new_speaker <- str_match(line, "^.+?:")
    if (!is.na(new_speaker) & str_length(new_speaker < 25)) {
      if (new_speaker == speaker) {
        # remove the new speaker and continue
        lineText <- str_replace(line, new_speaker, '')
      }
      else {
        # Insert an empty line and the full line
        speaker <- new_speaker
        lineText <- paste0("\n\n", line)
      }
    }
    else {
      lineText <- line
    }
    text <- paste0(text, lineText)
  }
  text <- str_remove(text, "^\\n+")
  return (text)
}


# Loop through files ------------------------------------------------------


file_list <- list.files()
for (file in file_list){
  # Ignore non-vtt files
  if(!str_detect(file, "\\.vtt$")) {
    next
  }
  else {
    # read in transcript
    transcript <-
      readr::read_file(file)
    # basic regex clean-up
    transcript <- regexClean(transcript)
    
    # line-by-line formatting
    transcript <- lineClean(transcript)
    
    # set new filename and save
    newFilename <- stringr::str_replace(file, "\\.vtt", "_cleaned.txt")
    readr::write_file(transcript, newFilename)
  }
}
