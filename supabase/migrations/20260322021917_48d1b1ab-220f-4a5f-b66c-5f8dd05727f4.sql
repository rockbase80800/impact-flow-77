
INSERT INTO storage.buckets (id, name, public)
VALUES ('application-documents', 'application-documents', false)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Users can upload application docs"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'application-documents' AND (storage.foldername(name))[1] = auth.uid()::text);

CREATE POLICY "Users can read own application docs"
ON storage.objects FOR SELECT TO authenticated
USING (bucket_id = 'application-documents' AND (storage.foldername(name))[1] = auth.uid()::text);

CREATE POLICY "Super admins can read all application docs"
ON storage.objects FOR SELECT TO authenticated
USING (bucket_id = 'application-documents' AND has_role(auth.uid(), 'super_admin'));
