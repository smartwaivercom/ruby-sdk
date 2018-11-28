#
# Copyright 2018 Smartwaiver
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

require 'smartwaiver-sdk/smartwaiver_base'

class SmartwaiverDynamicTemplateData

  attr_accessor :adult, :participants, :guardian

  def initialize(adult = true)
    @adult = adult
    @participants = []
    @guardian = SmartwaiverGuardian.new
  end

  def add_participant(participant)
    @participants.push(participant)
  end

  def for_json
    participants_for_json = []
    @participants.each do |participant|
      participants_for_json.push(participant.for_json)
    end
    {'adult' => @adult, 'participants' => participants_for_json, 'guardian' => @guardian.for_json}
  end
end

class SmartwaiverParticipant

  attr_accessor :first_name, :middle_name, :last_name, :phone, :gender, :dob

  def initialize()
    @first_name = nil
    @middle_name = nil
    @last_name = nil
    @phone = nil
    @gender = nil
    @dob = nil
  end

  def for_json
    json = {}
    json['firstName'] = @first_name  if (!@first_name.nil?)
    json['middleName'] = @middle_name  if (!@middle_name.nil?)
    json['lastName'] = @last_name  if (!@last_name.nil?)
    json['phone'] = @phone  if (!@phone.nil?)
    json['gender'] = @gender  if (!@gender.nil?)
    json['dob'] = @dob  if (!@dob.nil?)
    json
  end
end

class SmartwaiverGuardian

  attr_accessor :participant, :first_name, :middle_name, :last_name, :relationship, :phone, :gender, :dob

  def initialize(participant = false)
    @participant = participant
    @first_name = nil
    @middle_name = nil
    @last_name = nil
    @relationship = nil
    @phone = nil
    @gender = nil
    @dob = nil
  end

  def for_json
    json = {}
    json['participant'] = @participant  if (!@participant.nil?)
    json['firstName'] = @first_name  if (!@first_name.nil?)
    json['middleName'] = @middle_name  if (!@middle_name.nil?)
    json['lastName'] = @last_name  if (!@last_name.nil?)
    json['relationship'] = @relationship  if (!@relationship.nil?)
    json['phone'] = @phone  if (!@phone.nil?)
    json['gender'] = @gender  if (!@gender.nil?)
    json['dob'] = @dob  if (!@dob.nil?)
    json
  end
end



