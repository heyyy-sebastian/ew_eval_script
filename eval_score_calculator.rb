# Instructions for Use:
# Inside this folder, add the digital literacy csv downloaded from Google Forms.
# (To download: go to the Responses tab, click the 3 stacked dots, select download csv)
# Replace the file name on line 18 so the line reads csv_file = File.read('./your-file-name-here.csv')
# Open your terminal & navigate to the eval_score_calculator folder
# Type ruby eval_score_calculator.rb in the command line
# The digital_literacy_eval_scores.csv will be created in this same folder

# These instructions assume you have ruby installed on your machine
# To see if you have ruby installed, you can type ruby -v in your terminal
# To install ruby, see https://www.ruby-lang.org/en/documentation/installation/
require 'csv'

class EvalScoreCalculator
  ADVANCED_LEVEL_MAX = 86
  BEGINNER_LEVEL_MIN = 130

  csv_file = File.read('./replace_me.csv')
  parsed_csv = CSV.parse(csv_file, :headers => true)
  new_headers = ["Applicant Name", "Score", "Placement Level", "Recommend course?"]

  def self.beginner?(eval_score)
    eval_score >= BEGINNER_LEVEL_MIN
  end

  def self.intermediate?(eval_score)
    eval_score.between?(ADVANCED_LEVEL_MAX + 1, BEGINNER_LEVEL_MIN - 1)
  end

  def self.advanced?(eval_score)
    eval_score <= ADVANCED_LEVEL_MAX
  end

  def self.find_applicant_placement_level_and_recommend_training?(eval_score)
    if beginner?(eval_score)
      {
        level: "Beginner",
        recommend_course: "Yes"
      }
    elsif intermediate?(eval_score)
      {
        level: "Intermediate",
        recommend_course: "Optional"
      }
    elsif advanced?(eval_score)
      {
        level: "Advanced",
        recommend_course: "No"
      }
    else
      {
        level: "N/A",
        recommend_course: "N/A"
      }
    end
  end

  def self.sum_scores(individual_question_scores)
    individual_question_scores.reduce(0) { |sum, num| sum + num }
  end

  CSV.open("digital_literacy_eval_scores.csv", "w") do |csv|
    csv << new_headers
    parsed_csv.each do |row|
      applicant_name = row['First Name'] + " " + row['Last Name']

      individual_question_scores = []
      (5..46).each { |score| individual_question_scores.push(row[score].to_i) }

      eval_score = sum_scores(individual_question_scores)
      eval_outcome = find_applicant_placement_level_and_recommend_training?(eval_score)
      placement_level = eval_outcome[:level]
      recommend_course = eval_outcome[:recommend_course]

      csv << [applicant_name, eval_score, placement_level, recommend_course]
    end
  end
end
