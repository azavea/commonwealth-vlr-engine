module CommonwealthVlrEngine
  module CommonwealthSearchBuilderBehavior

    # only return items corresponding to the correct site
    def site_filter(solr_parameters = {})
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << '+destination_site_ssim:"' + CommonwealthVlrEngine.config[:site] + '"'
    end

    # keep file assets from appearing in search results
    def exclude_unwanted_models(solr_parameters = {})
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << '-has_model_ssim:"info:fedora/afmodel:Bplmodels_File"'
      solr_parameters[:fq] << '-has_model_ssim:"info:fedora/fedora-system:ContentModel-3.0"'
    end

    # keep draft/review and in-process items from appearing in search results
    def exclude_unpublished_items(solr_parameters = {})
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << '-workflow_state_ssi:"draft"'
      solr_parameters[:fq] << '-workflow_state_ssi:"needs_review"'
      solr_parameters[:fq] << '-processing_state_ssi:"derivatives"'
      # can't implement below until all records have this field
      # solr_parameters[:fq] << '+workflow_state_ssi:"published"'
      # solr_parameters[:fq] << '+processing_state_ssi:"complete"'
    end

    # keep Institution objects out of the search results
    def exclude_institutions(solr_parameters = {})
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << '-active_fedora_model_suffix_ssi:"Institution"'
    end

    # don't return flagged items (for series images on collections#show)
    def flagged_filter(solr_parameters = {})
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << "-#{blacklight_config.flagged_field}:[* TO *]"
    end

    # limit results to a single institution
    def institution_limit(solr_parameters = {})
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << '+institution_pid_ssi:"' + CommonwealthVlrEngine.config[:institution][:pid] + '"'
    end

    # used by InstitutionsController#index
    def institutions_filter(solr_parameters = {})
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << "+active_fedora_model_suffix_ssi:\"Institution\""
    end

    # for 'more like this' search -- set solr id param to params[:mlt_id]
    def mlt_params(solr_parameters = {})
      solr_parameters[:id] = blacklight_params[:mlt_id]
      solr_parameters[:qt] = 'mlt'
      solr_parameters[:mlt] = true
      solr_parameters[:'mlt.fl'] = 'subject_facet_ssim,subject_geo_city_ssim,related_item_host_ssim'
      solr_parameters[:'mlt.match.include'] = false
      solr_parameters[:'mlt.mintf'] = 1
      solr_parameters[:'mlt.qf'] = 'subject_facet_ssim^10 subject_geo_city_ssim^5 related_item_host_ssim'
    end

    # used by CollectionsController#index
    def collections_filter(solr_parameters = {})
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << "+active_fedora_model_suffix_ssi:\"Collection\""
    end

    # keep Volume objects out of the search results
    def exclude_volumes(solr_parameters = {})
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << '-active_fedora_model_suffix_ssi:"Volume"'
    end

    # set params for ocr field searching
    def ocr_search_params(solr_parameters = {})
      solr_parameters[:facet] = false
      solr_parameters[:hl] = true
      solr_parameters[:'hl.fl'] = blacklight_config.ocr_search_field
      solr_parameters[:'hl.fragsize'] = 135
      solr_parameters[:'hl.snippets'] = 10
    end

  end
end

