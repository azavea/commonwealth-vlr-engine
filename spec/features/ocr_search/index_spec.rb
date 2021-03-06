require 'spec_helper'

describe 'OCR search index view' do

  let(:book_pid) { 'bpl-dev:7s75dn48d' }

  describe 'loading the search form' do

    describe 'with no current_search_session params' do
      it 'should display the search form' do
        visit ocr_search_path(id: book_pid)
        expect(page).to have_selector('form.ocr-search-form')
      end
    end

    describe 'with current_search_session params' do

      before do
        visit search_catalog_path(q: 'foo')
      end

      it 'should display the suggestion link' do
        visit ocr_search_path(id: book_pid)
        expect(page).to have_selector('#ocr_search_suggest')
      end

    end

  end

  describe 'running a search' do

    before { visit ocr_search_path(id: book_pid) }

    describe 'no matches' do
      it 'should render the no matches partial' do
        within 'form.ocr-search-form' do
          fill_in 'ocr_q', with: 'sdfsdf'
          click_button('search')
        end
        expect(page).to have_selector('#zero_results_ocr')
      end
    end

    describe 'with matches' do

      before do
        within 'form.ocr-search-form' do
          fill_in 'ocr_q', with: 'the'
          click_button('search')
        end
      end

      it 'should display the sort widget' do
        expect(page).to have_selector('#sort-dropdown')
      end

      it 'should display the search results' do
        expect(page).to have_selector('.ocr_search_result', count: 2)
      end

      it 'should display the page link, snippets, term frequency, and more matches' do
        expect(page).to have_selector('.ocr_page_link', count: 2)
        expect(page).to have_selector('.first_snippet', count: 2)
        expect(page).to have_selector('.ocr_term_freq', count: 2)
        expect(page).to have_selector('.ocr_snippets_expand', count: 2)
      end

      it 'should have hidden snippets' do
        expect(page).to have_selector('#snippet_collapse_1', visible: false)
      end

      describe 'show hidden snippets' do

        before do
          page.find("a[href*='#snippet_collapse_1']").click
        end

        it 'should display more snippets' do
          expect(page).to have_selector('#snippet_collapse_1', visible: true)
        end

      end

    end

  end

end