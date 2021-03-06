require 'spec_helper'

describe DownloadsController do

  render_views

  before(:each) do
    @item_id = 'bpl-dev:h702q6403'
    @datastream_id = 'access800'
    @first_image_pid = 'bpl-dev:h702q641c'
  end

  describe "GET 'show'" do

    describe 'file object (single item download)' do

      it 'should be successful and set the right instance variables' do
        xhr :get, :show, :id => @first_image_pid, :datastream_id => @datastream_id
        expect(response).to be_success
        expect(assigns(:parent_document).id).to eq(@item_id)
        expect(assigns(:object_profile).class).to eq(Hash)
      end

    end

    describe 'top-level object (ZIP download)' do

      it 'should be successful and set the right instance variables' do
        xhr :get, :show, :id => @item_id, :datastream_id => @datastream_id
        expect(response).to be_success
        expect(assigns(:parent_document)).to eq(assigns(:document))
        expect(assigns(:object_profile)).to be_nil
      end

    end

  end

  describe "GET 'trigger_download'" do

    describe 'file object (single item download)' do

      it 'should be successful and set the right headers' do
        get :trigger_download, :id => @first_image_pid, :datastream_id => @datastream_id
        expect(response).to be_success
        expect(response.headers['Content-Type']).to eq('image/jpeg')
        expect(response.headers['Content-Disposition']).to eq("attachment; filename=\"#{@item_id}_#{@datastream_id}.jpg\"")
      end

    end

    describe 'top-level object (ZIP download)' do

      it 'should be successful and set the right instance variables' do
        get :trigger_download, :id => @item_id, :datastream_id => @datastream_id
        expect(response).to be_success
        expect(response.headers['Content-Type']).to eq('application/zip')
        expect(response.headers['Content-Disposition']).to eq("attachment; filename=\"#{@item_id}_#{@datastream_id}.zip\"")
      end

    end

  end

end
