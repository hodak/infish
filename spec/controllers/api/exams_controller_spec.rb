require 'rails_helper'

describe Api::ExamsController do
  describe 'update' do
    let(:id) { '70108314-cade-4fe4-b16a-5c2a2ccff55a' }
    let(:params) { {
      id: id,
      exam: {
        name: 'Exam name'
      }
    } }

    it "creates new exam if one doesn't exist" do
      expect { put :update, params }.to change { Exam.count }.by(1)
      expect(Exam.last.id).to eql id
    end

    it 'updates existing exam' do
      FactoryGirl.create(:exam, params[:exam].merge({ id: id }))
      params[:exam][:name] = 'Hodor'

      expect { put :update, params }.not_to change { Exam.count }
      expect(Exam.last.id).to eql id
      expect(Exam.last.name).to eql 'Hodor'
    end

    it 'returns exam in json' do
      put :update, params
      expect(parsed_body['exam']['id']).to eql id
      expect(parsed_body['exam']['name']).to eql 'Exam name'
      expect(parsed_body['exam']['questions']).to eql({})
    end

    it 'requires valid uuid in param' do
      params[:id] = 'e'
      put :update, params
      expect(parsed_body['error']['id']).to eql ['is invalid']
      expect(response.status).to eql 422
    end
  end
end