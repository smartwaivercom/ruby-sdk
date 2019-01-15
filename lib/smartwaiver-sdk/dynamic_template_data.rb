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

  attr_accessor :adult, :participants, :guardian, :address_line_one, :address_line_two, :address_country,
                :address_state, :address_zip, :email, :emergency_contact_name, :emergency_contact_phone,
                :insurance_carrier, :insurance_policy_number, :drivers_license_state, :drivers_license_number

  def initialize(adult = true)
    @adult = adult
    @participants = []
    @guardian = SmartwaiverGuardian.new
    @address_line_one = nil
    @address_line_two = nil
    @address_country = nil
    @address_state = nil
    @address_zip = nil
    @email = nil
    @emergency_contact_name = nil
    @emergency_contact_phone = nil
    @insurance_carrier = nil
    @insurance_policy_number = nil
    @drivers_license_state = nil
    @drivers_license_number = nil
  end

  def add_participant(participant)
    @participants.push(participant)
  end

  def for_json
    participants_for_json = []
    @participants.each do |participant|
      participants_for_json.push(participant.for_json)
    end
    json = {}
    json['adult'] = @adult
    json['participants'] = participants_for_json
    json['guardian'] = @guardian.for_json
    json['addressLineOne'] = @address_line_one  if (!@address_line_one.nil?)
    json['addressLineTwo'] = @address_line_two  if (!@address_line_two.nil?)
    json['addressCountry'] = @address_country  if (!@address_country.nil?)
    json['addressState'] = @address_state  if (!@address_state.nil?)
    json['addressZip'] = @address_zip  if (!@address_zip.nil?)
    json['email'] = @email  if (!@email.nil?)
    json['emergencyContactName'] = @emergency_contact_name  if (!@emergency_contact_name.nil?)
    json['emergencyContactPhone'] = @emergency_contact_phone  if (!@emergency_contact_phone.nil?)
    json['insuranceCarrier'] = @insurance_carrier  if (!@insurance_carrier.nil?)
    json['insurancePolicyNumber'] = @insurance_policy_number  if (!@insurance_policy_number.nil?)
    json['driversLicenseState'] = @drivers_license_state  if (!@drivers_license_state.nil?)
    json['driversLicenseNumber'] = @drivers_license_number  if (!@drivers_license_number.nil?)
    json
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



